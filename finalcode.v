module cache;
    //blockOffset = no of bits of block offset 
    //way_no - decimal, set_no_bits - taking bits cuz we assume log(set_no) = integer in base 2
    parameter blockOffset_bits = 3, input_way_no = 4, set_no_bits = 3, no_of_requests = 524;//blockOffset in number of bits format
    
    reg hit; //1 - current request is hit; 0 - current request is a miss
    reg [23: 0] address; //address accessed by current request
    parameter total_set_no=2**set_no_bits; //decimal format
    //to be calculated by manan
    reg counter_variable_bool=1'b0; //1 - all comparators have compared the tags
    parameter tag_size = 24-blockOffset_bits-set_no_bits; //no of bits required for tag + 1 valid bit
    reg [tag_size: 0] cache_overhead [0: (total_set_no - 1)][0: (input_way_no-1)]; //cache overhead - contains valid bits and tags
    reg bhatia_on, bit, dummy_enable; //bit - internal var of Replacement_Policy
    //bhatia_on - will be 1 whenever comparators have to be called
    reg [input_way_no: 0] hit_way; //kind of how decoder's output is given 
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
    integer file, line_num, a; // for reading from memory file
    reg [24:0] all_queries [0: (no_of_requests - 1)]; //query size = bool + address (24 bit))
    reg whichAlwaysBlocksToCall [15:0];

    //reading requests
    initial begin
        file = $fopen("sort.txt", "r"); //TODO: change name of file
        line_num = 0;
        while(! $feof(file))
            begin
                
                a = $fscanf(file, "%b", all_queries[line_num]);
                line_num = line_num + 1;
            end 
        requests_loaded=1'b1;
        hit=1'b0;
        for (integer x = 0; x < 16; x = x + 1) 
        begin
            whichAlwaysBlocksToCall[x] = 1'b0;
        end
    end

    //code to read each request
    reg [24: 0] curr_query; //query size = read/write + address (24 bit)
    // tag_size=tag_size-1; //removing the 1 bit used for valid bit
    reg [(tag_size-1): 0] incoming_tag; //tag of current request
    // tag_size=tag_size+1;
    reg [(set_no_bits-1 ): 0] setNumber; //offset size setnumber size
    reg write;//1 - current request is write request, 0 - current request is read request
    function DecodeUnit(input integer current_index);
        begin
            curr_query = all_queries[current_index];
           // $display("query",curr_query);
            write = curr_query[24:24];
            address = curr_query[23:0]; //query bits
            //$display("%b", address[23]);
            $display();
            // write_data = curr_query[7:0]; //query bits
            // blockOffset = address[1:0]; //offset bits
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

    //TODO: look for how to execute variable no of comparators in parallel - NISHITA
    // always @(posedge bhatia_on) begin
    //     for(integer p=0;p<input_way_no;p++) begin
    //     if(incoming_tag == cache_overhead[setNumber][p][tag_size: 1]) 
    //     begin
    //         if(cache_overhead[setNumber][p][0])
    //         begin
    //                 hit = 1'b1;
    //                 hit_way = p;
    //         end
    //     end
    //     counter_variable = counter_variable+1;
    // end
    // if(counter_variable == input_way_no) counter_variable_bool=1'b1;
    // end

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

    reg [(input_way_no-1):0] temp; //change with number of waynumbers
    function Replacement_Policy;
        input[(set_no_bits-1):0] set_no; //the set no of current request 
        input[(input_way_no-1):0] way_no; //extra bits for simplicity 
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
                temp = cache_lru_overhead[set_no][0]; //the way no of the block to be kicekd out
                for(integer j = 1;j<input_way_no;j= j+1) begin 
                    cache_lru_overhead[set_no][j-1] = cache_lru_overhead[set_no][j]; 
                end
                cache_lru_overhead[set_no][input_way_no-1] = temp;
                Replacement_Policy = temp;
            end
        end
    endfunction

    //cache requests
    //work after comparing tags and valid bits
    reg [(input_way_no-1): 0] blockToBeReplaced; //way number of block to be replaced --extra bits for simplicty
    
    //work to be done after tags of all the ways have been compared with incoming tag
    always @(posedge (counter_variable_bool)) 
    begin
        counter_variable=0;
        counter_variable_bool=1'b0;
        $display("Request number:",request_num); 
        request_num = request_num + 1;
        $display("Set number is ",setNumber, " Hit way is ",hit_way," Incoming tag is %b",incoming_tag );
        $display("hit:",hit);
        bhatia_on = 1'b0;
        if (hit == 1'b1)begin
            hits = hits + 1;
            $display("It's a hit. Number of hits now are: %0d", hits);
            blockToBeReplaced <= Replacement_Policy(setNumber, hit_way, 1'b1);
            if (write == 1'b1) begin
                //write
                $display("Data is written. Write Hit request is served");
                $display("Cache write hit block %b",cache_overhead[setNumber][hit_way]);
                processRequest = 1'b1; //this will be at end
            end
            else begin
                //read
                $display("Read data is %b\nRead Hit request is served",cache_overhead[setNumber][hit_way]);
                processRequest = 1'b1; //this will be at end
            end
            hit=1'b0;
        end
        else begin
            misses = misses + 1;
            $display("Its a miss. Number of misses now are: %0d", misses);
            blockToBeReplaced <= Replacement_Policy(setNumber, hit_way, 1'b0);
            $display("block to be replaced: ",temp);
            // $display("ele1 :",element1," ele2 :",element2," ele3 :",element3); //increase accor to waynumber
            cache_overhead[setNumber][temp][0:0] = 1'b1; //setting the valid bit
            cache_overhead[setNumber][temp][(tag_size):1] = incoming_tag[(tag_size-1):0]; //tag size
            $display("Set number: ",setNumber," block to be replaced: ",temp," tag",incoming_tag);
            $display("Cache miss block %b",cache_overhead[setNumber][temp]);
            if (write == 1'b1) begin
                //write
                $display("Write Miss request is served %b",cache_overhead[setNumber][temp]);
                processRequest = 1'b1; //this will be at end
            end
            else begin
                //read
                $display("Read Miss request is served");
                processRequest = 1'b1; //this will be at end
            end
        end
        if (request_num == no_of_requests) 
        begin
            $finish;
        end
        // $display();
    end
endmodule