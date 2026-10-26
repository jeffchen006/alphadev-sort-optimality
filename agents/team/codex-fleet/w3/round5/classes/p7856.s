# n=5 model=out iset=I1 prefix14_class=7856
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovg S0, P0
cmp P2, P1
cmovle P0, P2
cmovge P0, P1
cmovge P1, P2
cmp P0, P3
cmovle P2, P0
cmovle P0, P3
cmovle P3, P2
cmp S0, P1
cmovl S1, S0
