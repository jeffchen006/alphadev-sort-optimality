# n=5 model=out iset=I1 prefix14_class=8708
cmp P2, P1
cmovl S0, P1
cmovge S0, P2
cmovle P1, P2
mov P2, P0
cmp P0, P3
cmovle P2, P3
cmovg P0, P3
mov P3, S0
cmp S0, P2
cmovge P3, P2
cmovge P2, S0
cmp P0, P1
mov P2, P3
