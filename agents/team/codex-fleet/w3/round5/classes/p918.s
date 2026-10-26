# n=5 model=out iset=I1 prefix14_class=918
cmp P3, P2
cmovg S0, P3
cmovle S0, P2
cmovle P2, P3
cmp P1, P0
mov S2, P1
mov P3, S0
cmovge S2, P0
cmovge P0, P1
cmp P0, S0
mov S1, S2
cmovle S0, P0
cmovge P3, P0
cmovge P0, S0
