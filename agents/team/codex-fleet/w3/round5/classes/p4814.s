# n=5 model=out iset=I1 prefix14_class=4814
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovle P3, P0
cmp P2, P1
cmovge P0, P2
cmovge P2, P1
cmovg P1, P0
mov S1, P2
cmp P3, S1
cmovl P2, P3
cmovg S1, P3
cmp S0, P1
cmovle P2, P1
