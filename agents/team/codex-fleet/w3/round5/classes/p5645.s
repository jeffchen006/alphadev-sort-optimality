# n=5 model=out iset=I1 prefix14_class=5645
cmp P0, P1
mov S0, P1
cmovg S0, P0
cmovle P1, P0
mov S2, P2
cmp P3, S2
cmovge P2, P3
cmovl S2, P3
mov P0, S2
cmp S2, P1
cmovge P0, P1
cmovle S2, P1
cmp P2, S0
cmovle S1, P2
