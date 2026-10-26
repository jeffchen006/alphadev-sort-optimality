# n=5 model=out iset=I1 prefix14_class=2824
cmp P0, P1
mov S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P2, P3
cmovg S2, P3
cmovle S2, P2
cmovge P3, P2
cmp P0, P3
mov S1, P0
cmovl P0, P3
cmovle P3, S1
cmp S2, S0
cmovge P2, S2
