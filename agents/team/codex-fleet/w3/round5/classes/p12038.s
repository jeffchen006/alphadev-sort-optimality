# n=5 model=out iset=I1 prefix14_class=12038
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
mov S0, P2
cmp P2, P3
mov S1, P0
cmovge P2, P3
cmovl S0, P3
mov P2, S0
