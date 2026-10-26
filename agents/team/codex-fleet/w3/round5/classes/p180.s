# n=5 model=out iset=I1 prefix14_class=180
mov S1, P1
cmp P1, P2
mov S0, P0
cmovle S1, P2
cmovg P1, P2
cmp P3, P0
cmovle P0, P3
cmovl P3, S0
cmovl S0, P0
cmp P1, P0
cmovge P0, P1
cmovl S0, P1
mov S2, P0
cmp P3, S1
