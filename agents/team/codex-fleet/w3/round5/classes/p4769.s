# n=5 model=out iset=I1 prefix14_class=4769
mov S0, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
mov S1, P2
cmp S1, P0
cmovl S1, P0
cmovge P2, P0
cmp P2, P3
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P1, S1
cmovle P0, P1
