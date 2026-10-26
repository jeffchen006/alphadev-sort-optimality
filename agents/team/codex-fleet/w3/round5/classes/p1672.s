# n=5 model=out iset=I1 prefix14_class=1672
mov S1, P0
mov S0, P3
cmp P2, P0
cmovl P0, P2
cmovle P2, S1
cmp S0, P1
cmovge S0, P1
cmovg P1, P3
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmovl P3, S0
mov P0, P1
cmp P1, P2
