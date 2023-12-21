//000001111122222.......
class seq;
    rand int a[];
	constraint x{a.size==100;}
    constraint y{foreach(a[i])
		                a[i]=i/5;}
	function void post_randomize();
	    foreach(a[i])
		    $display("%0p",a);
	endfunction
endclass
module top();
    seq s;
	initial
	    begin
		    s=new();
			assert(s.randomize());
		end
endmodule

enum {monday,tuesday,wednesday,thursday}days;


always@(posedge clk)
    begin
	    clk<=~clk;
	end

interface a;
    logic d;
    logic a;
    wire c;
endinterface	
    						
class raghu;
    function void display();
	    $display("base calss");
	endfunction
endclass
class balu extends raghu;
    function void display();
	    $display("derived class");
	endfunction
endclass
module top();
    balu b;
	initial
	   begin
	       b=new();
		   b.display();
		end
endmodule

constraint c{a inside{[]};}
constraint c1{a dist{7:=5,5:/3};}

covergroup nam;
    a:coverpoint a{
	                b iff(0=>1)
					   { 
					       bins trans=(1=>0)
					   }
endgroup


module clk(clk,rst,clk_out);
    input clk,rst;
	output clk_out;
	reg [2:0]count;
	always@(posedge clk)
	    clk_out<=count[1];
endmodule 

class wrdriver extends uvm_driver(write_xtn);
    `uvm_component_utils(wrdriver)
	virtual ram_if vif;
	ram_config cfg;
	function new(string name="wrdriver",uvm_component parent);
	    super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(ram_config)::get(this,"","config",cfg))
		    `uvm_fatal("ram_config","cannot get the config")
	endfunction
	function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
		vif=cfg.vif;
    endfunction
    task run_phase(uvm_phase phase);
        forever
            begin
                seq_item_port.get_next_item();
                drive_item();
                seq_item_port.item_done();
            end  
    endtask
    task drive_item(write_xtn item);
	    vif.cb.addr<=item.addr;
		vif.cb.write<=item.write;
		vif.cb.datain<=item.datain;
	endtask
endclass
class ram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(ram_scoreboard)
	write_xtn write;
	read_xtn read;
	ram_config cfg;
	uvm_tlm_analysis_port#(write_xtn)fifo_wr;
	uvm_tlm_analysis_port#(read_xtn)fifo_rd;
	function new(string name="ram_scoreboard",uvm_component parent);
	    super.new(name,parent);
		fifo_rd=new("fifo_rd",this);
		fifo_wr=new("fifo_wr",this);
	endfunction
	task run_phase(uvm_phase phase);
	    fork
		    begin
			    forever
				    begin
			            fifo_wr.get(write);
						mem_write(write);
			        end
            end
			begin
			        begin
					   fifo_rd.get(read);
					   check_data(read);
					end
			end
		join
	endtask
	reg [64:0]refmodel[int];
	virtual function mem_write(write_xtn wd);
	    if(wd.write)
		    begin
			    refmodel[wd.address]=wd.data;
				wr_xtn_in ++;
			end
	endfunction
	virtual function void check_data(read_xtn rd);
	    read_xtn ref_xtn;
		$cast(ref_xtn,rd.clone());
		if(mem_read(ref_xtn))
		    begin
			    if(rd.compare(ref_xtn))
				    begin
					    `uvm_info(get_type_name(),"scoreboard data match successful",UVM_MEDIUM)
					     xtns_compared++;
					end
				else
				    `uvm_info(get_type_name(),"does not match",UVM_MEDIUM)
			end
		else
		    `uvm_info(get_type_name(),"no data was written in the address")
	endfunction
	virtual function bit mem_read(read_xtn rd);
	    if(rd.read)
		    begin
			    if(refmodel.exists(rd.address))
				    begin
		                rd.data=refmodel[rd.address];
						rd_xtn++;
						return(1);
					end
				else
				    begin
					    xtns_dropped++;
						rd.data=0;
						`uvm_info(get_type_name(),"no data was written in the address")
						return(0);
					end
			end
	endfunction
			    
		
