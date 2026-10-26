# n=5 model=out iset=I1 prefix14_class=1537
cmp P3, P2
mov S1, P0
mov S0, P2
cmovl S0, P3
cmovg P2, P3
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmp S0, S1
cmovge P3, S0
cmovg S0, S1
mov S2, P2
cmovge S1, P3
cmp P1, P2
