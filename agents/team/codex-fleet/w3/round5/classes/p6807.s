# n=5 model=out iset=I1 prefix14_class=6807
mov S0, P1
mov S1, P3
cmp P0, P3
cmovge P3, P0
cmovl S1, P0
cmovle P0, P3
cmp S0, P2
cmovg S0, P2
cmovle P1, P2
cmp P1, P3
cmovge P0, P1
cmovl P3, P1
cmp S0, S1
cmovge P2, S1
