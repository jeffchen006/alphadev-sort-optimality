# n=5 model=out iset=I1 prefix14_class=12751
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
mov S0, P0
cmp P0, P2
cmovl P0, P2
mov S2, P3
cmovl P2, S0
cmp P2, S2
cmovge S2, P2
cmovg P2, P3
cmp P0, P1
cmovge S1, P1
