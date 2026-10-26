# n=5 model=out iset=I1 prefix14_class=9237
cmp P1, P2
cmovg S2, P1
cmovle S2, P2
mov S0, P0
cmovle P2, P1
cmp P3, S0
cmovge P0, P3
cmovl S0, P3
cmp S0, P2
cmovle P1, P2
cmovle P2, S0
mov P2, P0
cmovle S0, P1
mov S1, S0
