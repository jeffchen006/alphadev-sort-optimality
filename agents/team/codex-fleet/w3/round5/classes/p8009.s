# n=5 model=out iset=I1 prefix14_class=8009
mov S1, P0
cmp P1, P0
cmovg P0, P1
cmovg P1, S1
mov S2, P1
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
mov S0, P0
cmovle P2, S1
cmp P3, P1
cmovl S2, P3
cmovge P1, P3
mov P3, P1
