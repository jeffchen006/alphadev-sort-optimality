# n=5 model=out iset=I1 prefix14_class=5786
cmp P1, P3
cmovl S0, P3
cmovle P3, P1
cmovge S0, P1
cmovg P1, P3
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P1, P2
cmovle P1, P2
cmovl P2, P3
cmp P0, S0
mov P2, P1
