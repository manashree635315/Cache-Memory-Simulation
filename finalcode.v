module cache;
    //blockOffset = no of bits of block offset 
    //way_no - decimal, set_no_bits - taking bits cuz we assume log(set_no) = integer in base 2
    parameter blockOffset_bits = 3, input_way_no = 4, set_no_bits = 3, no_of_requests = 41832;//blockOffset in number of bits format
    parameter total_set_no=2**set_no_bits; //decimal format
    parameter tag_size = 24-blockOffset_bits-set_no_bits; //no of bits required for tag + 1 valid bit

    reg hit = 1'b0; //1 - current request is hit; 0 - current request is a miss
    reg bhatia_on, bit, dummy_enable; //bit - internal var of Replacement_Policy, bhatia_on - will be 1 whenever comparators have to be called
    reg [23: 0] address; //address accessed by current request
    reg counter_variable_bool=1'b0; //1 - all comparators have compared the tags
    reg [tag_size: 0] cache_overhead [0: (total_set_no - 1)][0: (input_way_no-1)]; //valid bits and tags
    reg [input_way_no: 0] hit_way; 
    integer hits = 0, misses = 0, counter_variable=0;
    reg valid_bits_set = 1'b0; //tells if initially valid bits for all blocks have been set

    //setting valid bits
    initial begin
        for(integer i = 0; i < total_set_no; i = i + 1) begin //setnumber
            for(integer j = 0; j < input_way_no; j = j + 1) begin //waynumber
                cache_overhead[i][j][0] = 1'b0; 
            end
        end
        valid_bits_set = 1'b1; //after completion of setting of valid bits
    end

    reg requests_loaded = 1'b0;//tells if requests have been read from our trace 
    integer file, line_num, a; //variables required for reading from memory file
    reg [24:0] all_queries [0: (no_of_requests - 1)]; //query size = read/write bool(1 bit) + address (24 bit)
    reg [15:0] whichAlwaysBlocksToCall = 16'b0000000000000000; //16 bit register - the i'th comparator will be called on posedge of the i'th bit

    //reading requests
    initial begin
        file = $fopen("lu.txt", "r"); //change name of file according to the trace
        line_num = 0;
        while(! $feof(file))
            begin
                a = $fscanf(file, "%b", all_queries[line_num]);
                line_num = line_num + 1;
            end 
        requests_loaded=1'b1;
        hit=1'b0;
    end

    //code to read each request
    reg [24: 0] curr_query; //query size = read/write + address (24 bit)
    reg [(tag_size-1): 0] incoming_tag; //tag of current request
    reg [(set_no_bits-1 ): 0] setNumber; //offset size setnumber size
    reg write;//1 - current request is write request, 0 - current request is read request
    function DecodeUnit(input integer current_index);
        begin
            curr_query = all_queries[current_index];
            write = curr_query[24:24];
            address = curr_query[23:0]; //query bits
            $display();
            setNumber = address[(23-tag_size):(blockOffset_bits)]; //set number size
            incoming_tag = address[23:(24-tag_size)]; //tag size
            requests_loaded = 1'b1;
        end
    endfunction

    reg processRequest = 1'b0; //new request will be serviced at its posedge
    
    //start working after valid bits are set and requests are loaded
    always @(posedge (valid_bits_set && requests_loaded)) begin
        requests_loaded = 1'b0;
        processRequest = 1'b1;
    end

    reg callDecode; // a dummy variable required for calling the decodeUnit function
    integer request_num = 0;//index of current request
    always @(posedge processRequest) begin
        processRequest = 1'b0;
        callDecode <= DecodeUnit(request_num);
        bhatia_on = 1'b1;
        for (integer i = 0; i < input_way_no; i = i + 1)
        begin
            whichAlwaysBlocksToCall[i] = 1'b1;
        end 
    end

    always @(posedge (whichAlwaysBlocksToCall[0] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][0][tag_size: 1] && cache_overhead[setNumber][0][0]) 
        begin
            hit = 1'b1;
            hit_way = 0;
        end
        counter_variable_bool = 1'b1;
    end

    always @(posedge (whichAlwaysBlocksToCall[1] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][1][tag_size: 1] && cache_overhead[setNumber][1][0]) 
        begin
            hit = 1'b1;
            hit_way = 1;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[2] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][2][tag_size: 1] && cache_overhead[setNumber][2][0]) 
        begin
            hit = 1'b1;
            hit_way = 2;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[3] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][3][tag_size: 1] && cache_overhead[setNumber][3][0]) 
        begin
            hit = 1'b1;
            hit_way = 3;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[4] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][4][tag_size: 1] && cache_overhead[setNumber][4][0]) 
        begin
            hit = 1'b1;
            hit_way = 4;
        end
    end

always @(posedge (whichAlwaysBlocksToCall[5] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][5][tag_size: 1] && cache_overhead[setNumber][5][0]) 
        begin
            hit = 1'b1;
            hit_way = 5;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[6] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][6][tag_size: 1] && cache_overhead[setNumber][6][0]) 
        begin
            hit = 1'b1;
            hit_way = 6;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[7] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][7][tag_size: 1] && cache_overhead[setNumber][7][0]) 
        begin
            hit = 1'b1;
            hit_way = 7;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[8] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][8][tag_size: 1] && cache_overhead[setNumber][8][0]) 
        begin
            hit = 1'b1;
            hit_way = 8;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[9] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][9][tag_size: 1] && cache_overhead[setNumber][9][0]) 
        begin
            hit = 1'b1;
            hit_way = 9;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[10] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][10][tag_size: 1] && cache_overhead[setNumber][10][0]) 
        begin
            hit = 1'b1;
            hit_way = 10;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[11] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][11][tag_size: 1] && cache_overhead[setNumber][11][0]) 
        begin
            hit = 1'b1;
            hit_way = 11;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[12] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][12][tag_size: 1] && cache_overhead[setNumber][12][0]) 
        begin
            hit = 1'b1;
            hit_way = 12;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[13] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][13][tag_size: 1] && cache_overhead[setNumber][13][0]) 
        begin
            hit = 1'b1;
            hit_way = 13;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[14] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][14][tag_size: 1] && cache_overhead[setNumber][14][0]) 
        begin
            hit = 1'b1;
            hit_way = 14;
        end
    end

    always @(posedge (whichAlwaysBlocksToCall[15] && bhatia_on)) 
    begin
        if (incoming_tag == cache_overhead[setNumber][15][tag_size: 1] && cache_overhead[setNumber][15][0]) 
        begin
            hit = 1'b1;
            hit_way = 15;
        end
    end

    //replacement policy code
    //initially setting values
    reg[(input_way_no-1):0] cache_lru_overhead[0: (2**set_no_bits - 1)][0: (input_way_no-1)]; //regsize accor to waynumber also cache size will change
    initial begin  
        bit = 1'b0;
        for(integer i = 0; i<total_set_no; i=i+1) //setnumber
        begin
            for(integer j = 0; j<input_way_no; j = j+1) //waynumber
                begin 
                    cache_lru_overhead[i][j] = j;
                end
        end
    end

    reg [(input_way_no-1):0] replaceBlockNum; //change with number of waynumbers
    function Replacement_Policy;
        input[(set_no_bits-1):0] set_no; //the set no of current request 
        input[(input_way_no-1):0] way_no;
        input[0:0] hit;
    begin
        bit = 1'b0;
        if(hit == 1'b1)
            begin
                for(integer j = 0; j<input_way_no; j=j+1)
                    begin 
                        if(bit == 1'b1)
                            cache_lru_overhead[set_no][j-1] = cache_lru_overhead[set_no][j];
                        if(cache_lru_overhead[set_no][j] == way_no)
                            bit = 1'b1;   
                    end
                cache_lru_overhead[set_no][input_way_no-1] = way_no;    
                Replacement_Policy = cache_lru_overhead[set_no][0];
            end
        else //miss
            begin
                replaceBlockNum = cache_lru_overhead[set_no][0]; //the way no of the block to be kicked out in case of miss
                for(integer j = 1;j<input_way_no;j= j+1) begin 
                    cache_lru_overhead[set_no][j-1] = cache_lru_overhead[set_no][j]; 
                end
                cache_lru_overhead[set_no][input_way_no-1] = replaceBlockNum;
                Replacement_Policy = replaceBlockNum;
            end
        end
    endfunction

    //cache requests
    //work after comparing tags and valid bits
    reg [(input_way_no-1): 0] blockToBeReplaced; //way number of block to be replaced
    
    //work to be done after tags of all the ways have been compared with incoming tag
    always @(posedge (counter_variable_bool)) 
    begin
        counter_variable=0;
        counter_variable_bool=1'b0;
        $display("Request number:",request_num + 1); 
        request_num = request_num + 1;
        $display("Set number is ",setNumber, " Hit way is ",hit_way," Incoming tag is %b",incoming_tag );
        bhatia_on = 1'b0;
        if (hit == 1'b1)begin
            hits = hits + 1;
            $display("It's a hit");
            blockToBeReplaced <= Replacement_Policy(setNumber, hit_way, 1'b1);
            if (write == 1'b1) begin
                //write
                $display("Write Hit request is served");
                processRequest = 1'b1; //this will be at end
            end
            else begin
                //read
                $display("Read Hit request is served");
                processRequest = 1'b1; //this will be at end
            end
            hit=1'b0;
        end
        else begin
            misses = misses + 1;
            $display("Its a miss");
            blockToBeReplaced <= Replacement_Policy(setNumber, hit_way, 1'b0);
            $display("way no of block to be replaced: %0d Outgoing tag: %b", replaceBlockNum, cache_overhead[setNumber][replaceBlockNum][tag_size:1]);
            cache_overhead[setNumber][replaceBlockNum][0:0] = 1'b1; //setting the valid bit
            cache_overhead[setNumber][replaceBlockNum][(tag_size):1] = incoming_tag[(tag_size-1):0]; //tag size
            if (write == 1'b1) begin
                //write
                $display("Write Miss request is served ");
                processRequest = 1'b1; //this will be at end
            end
            else begin
                //read
                $display("Read Miss request is served");
                processRequest = 1'b1; //this will be at end
            end
        end
        begin
            $display("Current no of hits = %0d and misses = %0d", hits, misses);
        end
        if (request_num == no_of_requests) 
        begin
            #2 $finish;
        end
    end
endmodule
