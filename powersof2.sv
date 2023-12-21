//constraint for powers of 2;
class cons;
    rand int a[];
    constraint x{a.size==20;}
    constraint y{foreach(a[i])
	                a[i]==2**i;}
    function void post_randomize();
        $display("randomized values are %0p",a);
    endfunction
endclass
module power();
    cons c;
    initial
        begin
            c=new();
            assert(c.randomize());
        end
endmodule		