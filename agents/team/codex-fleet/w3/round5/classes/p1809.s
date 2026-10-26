# n=5 model=out iset=I1 prefix14_class=1809
cmp P0, P3
mov S1, P3
mov S0, P1
cmovge P3, P0
cmovg P0, S1
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmp P3, S0
cmovle S1, P3
cmovle P3, S0
cmovge S1, S0
cmp P2, P0
cmovge P3, P0
