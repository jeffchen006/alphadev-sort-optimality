# n=5 model=out iset=I1 prefix14_class=4137
mov S0, P2
cmp P1, S0
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovg S1, P0
cmovle S1, P3
mov S2, S1
cmovg P0, P3
cmp S0, S2
cmovg S1, S0
cmovg S0, S2
cmp P0, P2
cmovle S0, P2
