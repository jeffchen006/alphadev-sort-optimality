# n=5 model=out iset=I1 prefix14_class=10872
mov S0, P3
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P0, P3
cmovge P3, P0
cmovl S0, P0
cmp P3, P2
cmovg P0, P3
cmovle P0, P2
cmovle P2, P3
cmp P1, S0
cmovle P3, S0
