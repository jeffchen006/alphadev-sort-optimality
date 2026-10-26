# n=5 model=out iset=I1 prefix14_class=12738
mov S1, P1
cmp P2, P1
cmovl S1, P2
cmovg P1, P2
cmp P0, P3
mov P2, P0
cmovl P0, P3
cmovle P3, P2
cmp P3, S1
cmovge S0, S1
cmovg S1, P3
cmovge P3, S0
cmp P0, P1
mov P3, S1
