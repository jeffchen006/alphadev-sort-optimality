# n=5 model=out iset=I1 prefix14_class=8656
mov S0, P2
cmp P2, P0
cmovg P2, P0
cmovl S0, P0
mov P0, P1
cmp P3, P0
cmovl P1, P3
cmovle P3, P0
cmp S0, P3
cmovg P0, S0
cmovle P0, P3
cmovge S0, P3
cmp P1, P2
cmovge P0, P1
