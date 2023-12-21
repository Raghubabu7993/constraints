class mat;
    rand int a[4][4];
	constraint x{foreach(a[i])
	                foreach(a[i][j])
					    if(i-j==0)//for diagnoal i=j;
						//if(i+j==3)//for diagnoal i+j==3;
						    a[i][j]==1;
						else
						    a[i][j]==0;}
	constraint v{foreach(a[i])
	                foreach(a[i][j])
                        a[i][j] inside {[0:100]};}
    function void post_randomize();
        $display("%0p",a);
    endfunction
endclass
module diagnoal();
    mat m;
    initial
        begin
            m=new();
            assert(m.randomize());
        end
endmodule