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
		//with out using sort method
		foreach(a[i])
			begin
				for(int j=i+1;j<$size(a);j++)
					begin
						if(a[i]>a[j])
							begin
								a[i]=a[i]+a[j];
								a[j]=a[i]-a[j];
								a[i]=a[i]-a[j];
							end
					end
			end
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

		
