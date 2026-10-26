# n=5 model=out iset=I1 prefix14_class=10870
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
mov S0, P3
cmovg P0, S1
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp S0, P0
cmovge P1, S0
cmovl P1, P0
cmovle P0, S0
cmp P2, P3
cmovl S0, P3
