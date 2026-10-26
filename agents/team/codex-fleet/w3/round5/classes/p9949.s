# n=5 model=out iset=I1 prefix14_class=9949
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
cmovge S0, P1
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovge P3, S1
cmp S0, P3
cmovge P1, S0
cmovg S0, P3
cmovge P3, P1
mov P3, P0
cmp P3, P2
