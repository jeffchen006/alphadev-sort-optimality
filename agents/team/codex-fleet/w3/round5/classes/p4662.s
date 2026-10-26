# n=5 model=out iset=I1 prefix14_class=4662
mov S1, P0
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
mov S1, P1
cmp P1, P2
cmovl S1, P2
cmovg P1, P2
cmp P3, P0
mov S0, P3
