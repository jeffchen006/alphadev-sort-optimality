# n=5 model=out iset=I1 prefix14_class=8655
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
mov P0, P3
cmp P1, P0
cmovl P3, P1
cmovl P1, P0
cmp S0, P1
cmovg P0, S0
cmovle P0, P1
cmovge S0, P1
cmp P2, P3
cmovge P0, P2
