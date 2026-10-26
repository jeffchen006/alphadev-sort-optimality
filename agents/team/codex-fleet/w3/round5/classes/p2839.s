# n=5 model=out iset=I1 prefix14_class=2839
cmp P3, P0
cmovl S0, P0
cmovge S0, P3
cmovge P3, P0
cmp P1, P2
mov P0, P1
cmovge P1, P2
cmovge P2, P0
cmp P2, S0
mov P0, S0
cmovge S0, P2
cmovle P0, P2
cmp P1, P3
cmovge P2, P0
