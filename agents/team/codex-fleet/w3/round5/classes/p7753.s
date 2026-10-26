# n=5 model=out iset=I1 prefix14_class=7753
mov S2, P3
cmp S2, P1
mov S0, P0
cmovg S2, P1
cmovl P3, P1
cmp S0, P2
cmovle P0, P2
cmovg S0, P2
cmp S2, S0
cmovg P2, S0
cmovg S0, S2
cmovg S2, P2
cmp P0, P3
cmovle P1, P3
