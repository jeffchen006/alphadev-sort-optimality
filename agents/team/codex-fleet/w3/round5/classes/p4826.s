# n=5 model=out iset=I1 prefix14_class=4826
cmp P1, P2
mov S2, P0
cmovle S0, P2
cmovle P2, P1
cmovg S0, P1
cmp P0, P3
mov S1, P2
cmovge P0, P3
cmovge P3, S2
cmp P0, P2
cmovl S1, P0
cmovge P2, P0
cmp S0, P3
mov P0, P2
