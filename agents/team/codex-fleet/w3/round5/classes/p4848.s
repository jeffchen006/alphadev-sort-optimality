# n=5 model=out iset=I1 prefix14_class=4848
mov S2, P2
cmp P1, S2
cmovle P2, P1
cmovg S2, P1
mov S1, P0
cmp P0, P3
cmovg S1, P3
mov P1, S1
cmovge P3, P0
cmp P2, S1
cmovg P1, P2
cmovl S1, P2
cmp P3, S2
cmovle S0, S2
