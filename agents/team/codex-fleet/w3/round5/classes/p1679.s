# n=5 model=out iset=I1 prefix14_class=1679
cmp P0, P3
cmovge S1, P3
mov S0, P2
cmovge P3, P0
cmovle S1, P0
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
cmovge P2, S0
cmp P2, S1
cmovle P2, S1
cmovg S0, S1
cmp P3, P1
cmovg P0, P1
