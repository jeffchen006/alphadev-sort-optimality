# n=5 model=out iset=I1 prefix14_class=5732
cmp P1, P0
mov S0, P2
cmovge S1, P0
cmovle S1, P1
cmovge P0, P1
cmp P3, S0
cmovge P2, P3
cmovg P3, S0
mov P1, S1
cmp S1, P3
cmovle P1, P3
cmovg S1, P3
mov S1, P2
cmovge P3, P1
