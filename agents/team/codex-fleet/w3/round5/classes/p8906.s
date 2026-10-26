# n=5 model=out iset=I1 prefix14_class=8906
mov S0, P3
mov S1, P0
cmp P0, P2
cmovg S1, P2
cmovl P0, P2
cmp P1, S0
cmovl P3, P1
cmovle P1, S0
mov S0, P0
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmp S1, P3
cmovg P2, P3
