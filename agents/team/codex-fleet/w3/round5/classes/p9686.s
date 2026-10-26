# n=5 model=out iset=I1 prefix14_class=9686
mov S0, P3
cmp P2, P3
cmovle P3, P2
cmovg S0, P2
cmp P0, P1
mov P2, P1
cmovl P2, P0
cmovle P0, P1
mov P1, S0
cmp S0, P0
cmovge S0, P0
cmovg P0, P1
cmp P3, P2
cmovge P1, S0
