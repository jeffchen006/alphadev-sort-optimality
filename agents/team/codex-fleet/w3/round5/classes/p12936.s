# n=5 model=out iset=I1 prefix14_class=12936
mov S0, P2
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
mov P0, S0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P0, P3
cmovle P0, P3
cmovg S0, P3
cmp P1, P2
cmovle P3, P2
