# n=5 model=out iset=I1 prefix14_class=4816
mov S0, P3
cmp P1, P3
cmovge S0, P1
cmovle P3, P1
mov P1, P2
cmp P1, P0
cmovge P1, P0
cmovg P0, P2
mov S1, P1
cmp P3, P1
cmovl S1, P3
cmovg P1, P3
cmp P0, S0
cmovle P2, S0
