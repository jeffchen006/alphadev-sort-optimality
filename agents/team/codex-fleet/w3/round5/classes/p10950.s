# n=5 model=out iset=I1 prefix14_class=10950
cmp P2, P0
mov S0, P0
cmovle P0, P2
cmovle P2, S0
cmp P1, P3
cmovg S1, P1
cmovge P1, P3
mov S0, P2
cmovg P3, S1
cmp P3, S0
cmovge P2, P3
cmovl S0, P3
cmp P0, P1
cmovl P3, P1
