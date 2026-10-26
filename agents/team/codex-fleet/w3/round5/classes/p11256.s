# n=5 model=out iset=I1 prefix14_class=11256
cmp P0, P2
mov S0, P2
cmovge S0, P0
cmovge P0, P2
cmp P1, P3
mov P2, P3
cmovge P2, P1
cmovg P1, P3
cmp S0, P2
mov P3, S0
cmovle P3, P2
cmovl P2, S0
mov P3, P0
cmovg S0, P2
