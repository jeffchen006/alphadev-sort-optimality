# n=5 model=out iset=I1 prefix14_class=5737
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovg P1, S0
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
cmp P0, P3
mov S0, P0
