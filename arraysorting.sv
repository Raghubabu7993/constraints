module sorting();
class sr;
    int q[$];
	int a;
	constraint c{q.size inside {[10:20]};}
	constraint c1{foreach(q[i])
	                q[i] inside {[1:100]};}
	function void post_randomize();
	    $display("elements in array %0p",q);
		q.sort();
		a=q[$-1];
		$display("second largest num is %0d",a);
	endfunction
endclass
sr s;
initial
    begin
	    s=new();
		assert(s.randomize);
	end
endmodule

		