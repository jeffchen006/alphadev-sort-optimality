# n=5 model=out iset=I1 prefix14_class=1838
mov S2, P0
mov S1, P2
cmp P3, P0
cmovg P0, P3
cmovge P3, S2
cmp P1, S1
cmovg P2, P1
cmovg P1, S1
cmp P2, P0
mov S0, P2
cmovge P2, P0
cmovle S0, P0
cmp P3, P1
cmovl S0, P3
