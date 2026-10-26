# n=5 model=out iset=I1 prefix14_class=7682
mov S1, P3
cmp P1, P3
cmovge P3, P1
cmovl S1, P1
cmp P0, P2
cmovle S2, P0
mov S0, P3
cmovl P0, P2
cmovle P2, S2
mov P1, P2
cmp P2, S1
cmovl P2, S1
cmovl S1, P1
cmp P0, S0
