module cons;
class con;
    rand int a[];
	//int b[];
	constraint c{a.size==10;}
	constraint c2{foreach(a[i])
	                a[i] inside {[1:20]};}
	constraint c3{foreach(a[i]) // without using unique keyword
	                foreach(a[j])
					    if(i!=j)
						    a[i]!=a[j];}
	constraint c1{foreach(a[i])
	                a[i]%2==0;}
    constraint c4{unique{a};}// using unique keyword
    function void post_randomize();
	    a.sort();
	    $display("randomize values are %0p",a);
	endfunction
endclass
con s;
initial
    begin
	    s=new();
		assert(s.randomize);
	end
endmodule


class sub;
    int b;
	function sub copy();
	    copy=new();
		copy.b=this.b;
	endfunction
endclass
class main;
    sub s=new();
    int a;
	function main copy();
	    copy=new();
		copy.a=this.a;
		copy.s.=this.s.copy(); 
	endfunction
endclass
module shall();
    main m1,m2;
	initial
	    begin
		    m1=new();
			m1.a=50;
			m1.s.b=90;
			m2=m1.copy();
			m2.s.b=100;
			$display("value of a is %0d",m2.a);
			m2.a=10;
			$display("value of a is %0d and %0d",m1.a,m2.a);
			$display("address of handles are %0d and %0d",m1,m2);
		end
endmodule
	


class a;
    string raghu;
	mailbox#(string) m;
	function new(mailbox m1);
	    this.m=m1;
	endfunction
	task send();
	    raghu="good man";
		m.put(raghu);
	    $display("transmitted data %0s",raghu);
	endtask
endclass
class b;
	mailbox#(string) m2;
	function new(mailbox m2);
	    this.m=m2;
	endfunction
	task receive();
		m.get(raghu);
		$display("received value is %0s",raghu);
	endtask
endclass
module top();
    a a1;
	b b1;
	mailbox mb=new();
	initial
	    begin
	    a1=new(mb);
		b1=new(mb);
		a1.send;
		b1.receive();
		end
endmodule

module test();
    integer a=0;
	initial
	    begin
		    #2 a=#2 2;
			   a<=#3 3;
			#2 a=4;
			#2 a<=5;
			#2 a=#2 6;
			   a=#2 7;
			   a<=#2 8;
			#2 a<=#2 9;
			#3 a=10;
		end
	initial
	    $monitor("time = %0d,  a=%0d",$time,a);
endmodule
			

module fsm(clk,din,dout,rst);
    input clk,din,rst;
	output dout;
	parameter idle = 3'b000;
	parameter s1   = 3'b001;
	parameter s10  = 3'b010;
	parameter s101 = 3'b011;
	parameter s1010= 3'b100;
	reg [2:0]state;
	always@(posedge clk)
	    begin
		    if(rst)
			    state<=idle;
            else
			    begin
				    case(state)
					    idle: begin
						      if(din)  state <= s1;
							  else     state <= idle;
							  end
						s1:   begin
						      if(din)  state <= s1;
							  else     state <= s10;
							  end
					    s10:  begin
						      if(din)  state <= s101;
							  else     state <= idle;
							  end
						s101: begin
						      if(din)  state <= s1;
							  else     state <= s1010;
							  end
						s1010:begin
						      if(din)  state <= s1;
							  else     state <= idle;
							  end
							  default : state<=idle;
					endcase
				end
		end
	assign out = (state==s1010)?1'b1:1'b0;
endmodule
                        							  
    