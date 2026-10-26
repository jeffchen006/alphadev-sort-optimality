# n=5 model=out iset=I1 prefix14_class=13798
mov S1, P0
cmp P0, P2
cmovl S1, P2
mov S0, P3
cmovge P0, P2
cmp P3, P1
cmovle P3, P1
mov S2, P3
cmovg S0, P1
cmp P3, S1
cmovl S2, S1
cmovg P3, S1
cmp S0, P0
cmovle S2, S0
