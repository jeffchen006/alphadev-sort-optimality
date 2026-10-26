# n=5 model=out iset=I1 prefix14_class=10987
cmp P1, P3
mov S1, P3
mov S0, P0
cmovle P3, P1
cmovg S1, P1
cmp P2, S0
cmovge P0, P2
cmovl S0, P2
cmp P0, S1
cmovle P2, P0
cmovl P0, S1
cmovl S1, P2
cmp P3, S0
cmovl P2, S0
