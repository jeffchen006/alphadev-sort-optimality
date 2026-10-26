# n=5 model=out iset=I1 prefix14_class=12761
cmp P3, P1
cmovge S2, P3
cmovge P3, P1
cmovl S2, P1
cmp P0, P2
mov P1, P3
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P2, P1
cmovge P3, P2
cmovge P2, P1
mov P2, S2
cmp P0, S2
