# n=5 model=out iset=I1 prefix14_class=3943
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovg S0, P0
mov P0, P2
cmp P0, P1
cmovle P2, P1
cmovle P1, P0
cmp P3, P1
mov P0, P1
cmovg P1, P3
cmovl P0, P3
mov P3, S0
cmp S0, P2
