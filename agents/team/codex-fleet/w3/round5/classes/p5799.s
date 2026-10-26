# n=5 model=out iset=I1 prefix14_class=5799
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovle S2, P3
cmp P1, P0
mov S0, S2
cmovge P3, P1
cmovg P1, P0
cmovg P0, P3
cmp P1, S2
cmovle S0, P1
cmovge S2, P1
cmp P2, P0
mov S0, P0
