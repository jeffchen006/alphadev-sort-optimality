# n=5 model=out iset=I1 prefix14_class=7676
mov S0, P1
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
mov S2, S0
cmp P3, S2
cmovl S2, P3
cmovg S0, P3
cmp P0, P2
cmovge P3, P0
