# n=5 model=out iset=I1 prefix14_class=11320
cmp P0, P1
cmovge S2, P1
cmovle S2, P0
cmovle P0, P1
mov S0, S2
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
mov S1, P3
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovg P3, P0
