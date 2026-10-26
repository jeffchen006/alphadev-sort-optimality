# n=5 model=out iset=I1 prefix14_class=13435
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P1, P3
cmovl S0, P3
cmovle P3, P1
cmovge S0, P1
cmp P3, P2
cmovle P1, P2
cmovle P2, P3
cmovle P3, P1
cmp P0, S0
mov P2, P0
